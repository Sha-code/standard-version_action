const core = require("@actions/core");
const standardVersion = require("standard-version");
const { exec } = require("child_process");

// most @actions toolkit packages have async methods
async function run() {
  try {
    const githubToken = core.getInput("github_token");
    if (!githubToken) {
      throw "Missing githubToken";
    }
    core.info("Create Bump");
    const options = {};
    const prerelease = core.getInput("prerelease");
    if (prerelease) {
      options["prerelease"] = prerelease;
    }
    core.info("Running standar version");
    await standardVersion(options);
    core.info("Configuring git user and email...");
    await exec('git config --local user.email "action@github.com"');
    await exec('git config --local user.name "GitHub Action"');
    core.info("Pushing to branch...");
    const remoteRepo = `https://${process.env.GITHUB_ACTOR}:${githubToken}@github.com/${process.env.GITHUB_REPOSITORY}.git`;
    await exec(
      `git push "${remoteRepo}" HEAD:${process.env.GITHUB_REF} --follow-tags --tags`
    );
    const pjson = require("./package.json");
    core.info(`Released version ${pjson.version}`);
    core.setOutput("version", pjson.version);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
