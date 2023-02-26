// deno-lint-ignore-file no-fallthrough
import * as path from "https://deno.land/std@0.178.0/path/mod.ts";
import _chalk from "npm:chalk@4.1.0";
import YAML from "npm:yaml@2.2.1";
import { z } from "npm:zod@3.20.5";

const chalk = new _chalk.Instance({ level: 3 });

class Config {
  public static runrc = path.join(Deno.cwd(), ".runrc");
}

const RunnerSchema = z.strictObject({
  command: z.string(),
  args: z.array(z.string()).optional().default([]),
});

const RunConfigSchema = z.strictObject({
  // TODO: add support for importing other runrc files
  // imports: z.array(z.string()).optional(),
  runner: RunnerSchema.optional(),
  commands: z.array(
    z.strictObject({
      alias: z.string(),
      name: z.string(),
      runner: RunnerSchema.optional(),
      run: z.string(),
    })
  ),
});

class RunConfig {
  private config?: z.infer<typeof RunConfigSchema>;

  public async load() {
    const text = await Deno.readTextFile(Config.runrc);
    const data = YAML.parse(text);

    this.config = RunConfigSchema.parse(data);
  }

  public getConfig() {
    if (!this.config) {
      throw new Error("RunConfig not loaded");
    }
    return this.config;
  }

  private getCommandConfig(alias: string) {
    const config = this.getConfig();
    const command = config.commands.find((command) => command.alias === alias);
    if (!command) {
      return null;
    }
    const commandWithRunner = structuredClone(command);
    if (!commandWithRunner.runner) {
      commandWithRunner.runner = config.runner || {
        command: "zsh",
        args: ["-c"],
      };
    }

    return commandWithRunner;
  }

  public async runCommand(alias: string) {
    const command = this.getCommandConfig(alias);
    if (!command) {
      console.log(chalk.bold.bgRed(` No command found for alias ${alias} `));
      return 1;
    }

    // find all instances of __0, __1, etc and replace with the arguments
    let run = command.run;
    const args = Deno.args.slice(1);
    for (let i = 0; i < args.length; i++) {
      run = run.replace(`__${i}`, Deno.args[i]);
    }

    // replace all instances of __@ with the arguments
    run = run.replace(/__@/g, args.join(" "));

    // run the command
    const process = Deno.run({
      cmd: [command.runner.command, ...command.runner.args, run],
    });

    const status = await process.status();

    return status.code;
  }

  public listCommands() {
    const config = this.getConfig();
    const commands = config.commands.map(({ alias }) =>
      this.getCommandConfig(alias)
    );
    console.log(chalk.bold.bgBlue(" COMMANDS "));
    for (const command of commands) {
      console.log(chalk.bold("Name: ") + chalk.italic(command.name));
      console.log(chalk.bold("Alias: ") + chalk.italic(command.alias));
      console.log(
        chalk.bold("Runner: ") +
          chalk.italic(
            [command.runner.command, ...command.runner.args].join(" ")
          )
      );
      if (Deno.args.includes("--verbose") || Deno.args.includes("-v")) {
        console.log(chalk.bold("Run: "));
        console.log(chalk.italic(command.run));
      }
      console.log("");
    }
  }
}

function usage() {
  console.log(chalk.bold("Usage: ") + chalk.italic("run <alias>"));
  console.log("");
}

async function main() {
  const config = new RunConfig();
  await config.load();

  const alias = Deno.args.at(0);

  if (!alias) {
    // Log usage
    console.log(
      chalk.bold.bgRed(" ERROR ") + chalk.bold.red(" No alias provided")
    );
    console.log("");
    usage();
    Deno.exit(1);
  }

  switch (alias) {
    case "--help":
    case "-h":
      usage();
      Deno.exit(0);
    case "--list-commands":
    case "-l":
      await config.listCommands();
      Deno.exit(0);
  }

  const exitCode = await config.runCommand(alias);

  Deno.exit(exitCode);
}

main();
