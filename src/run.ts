import * as path from "https://deno.land/std@0.178.0/path/mod.ts";
import _chalk from "npm:chalk@4.1.0";
import YAML from "npm:yaml@2.2.1";
import { z } from "npm:zod@3.20.5";

const chalk = new _chalk.Instance({ level: 3 });

class Config {
  public static runrc = path.join(Deno.cwd(), ".runrc");
}

const RunConfigSchema = z.strictObject({
  commands: z.array(
    z.strictObject({
      alias: z.string(),
      name: z.string(),
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

  public async runCommand(alias: string) {
    const config = this.getConfig();
    const command = config.commands.find(
      (command) => command.alias === alias
    );
    if (!command) {
      console.log(chalk.bold.bgRed(` No command found for alias ${alias} `));
      return 1;
    }

    // find all instances of __0, __1, etc and replace with the arguments
    const args = Deno.args.slice(1).filter((arg) => {
      return !arg.startsWith("--");
    });
    let run = command.run;
    for (let i = 0; i < args.length; i++) {
      run = run.replace(`__${i}`, args[i]);
    }

    // replace all instances of __@ with the arguments
    run = run.replace(/__@/g, args.join(" "));

    if (Deno.args.includes("--verbose")) {
      console.log(chalk.bold.bgBlue(" RUNNING "));
      console.log(chalk.bold("Name: ") + chalk.italic(command.name));
      console.log(chalk.bold("Alias: ") + chalk.italic(command.alias));
      console.log(chalk.bold("Run: ") + chalk.italic(run));
    }

    if (Deno.args.includes("--dry-run")) {
      console.log(chalk.bold.bgYellow(" DRY RUN "));
      return 0;
    }
      
    const process = Deno.run({
      cmd: ["zsh", "-c", run],
    });

    const status = await process.status();

    return status.code;
  }
}

async function main() {
  const config = new RunConfig();
  await config.load();

  const alias = Deno.args.at(0);

  if (!alias) {
    // Log usage
    console.log(chalk.bold.bgRed(" ERROR ") + chalk.bold.red(" No alias provided"));
    console.log("");
    console.log(chalk.bold("Usage: ") + chalk.italic("run <alias>"));
    console.log("");
    Deno.exit(1);
  }

  const exitCode = await config.runCommand(alias);

  Deno.exit(exitCode);
}

main();
