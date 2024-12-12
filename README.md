### ⚠️ Archived - Freenom no longer works. In addition, free TLDs, if they even still exist, are usually blacklisted for fraud prevention. Please use a [free subdomain](https://freedns.afraid.org/) or a [paid domain](https://porkbun.com/).

### `freenom-docker`, a wrapper for `freenom-script` intended for use with cloud providers.

**Usage**:

1) Build the container with your email and password.
    * `docker build . -t freenom-docker --build-arg FREENOM_EMAIL="me@example.com" --build-arg FREENOM_PASSWORD="YOUR_PASSWORD_HERE"`

2) Run the container.
    * `docker run -it freenom-docker -- -l` (List domain(s))
    * `docker run -it freenom-docker -- -r example.com` (Renew domain(s))
    * Other commands, such as DNS modification, are not intended by this wrapper but still work. For documentation of these, see [`freenom-script`'s README](https://github.com/mkorthof/freenom-script/blob/master/README.md)

3) (Optional) Export the container for cloud providers.
    * **Warning**: Any moderately skilled software engineer will be able to reverse engineer your email and password from the docker image. Only share it with cloud providers you trust!
    * `docker save freenom-docker > freenom.tar`

**Freenom Renewal with Google Cloud**:

1) Fork this repository.
    * This is required to mirror the repository on [Cloud Source](https://source.cloud.google.com).
2) Create a new project on [Google Cloud](https://console.cloud.google.com).
3) Go to [Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts).
    * Create a service account named "Freenom Invoker".
    * Grant the project the roles called "Cloud Scheduler Admin" and "Cloud Run Invoker".
    * Leave everything else as default, and click "Done".
    * Make note of the Service Account Email. Make sure it is the "freenom-invoker" email.
4) Go to [Cloud Source](https://source.cloud.google.com).
    * Click "Add repository".
    * Select your project.
    * Connect to your GitHub account and select `freenom-docker`.
5) Go to [Cloud Run](https://console.cloud.google.com/run).
    * Create a service named "freenom".
    * Check "Continuously deploy new revisions from a source repository", and "Set up with Cloud Build".
    * Change "Repository Provider" to "Cloud Source Repositories" and enable all the APIs it warns you about.
    * Select the repository you created in the previous step and click "Next".
    * Select "Dockerfile" and click "Save".
    * Under "Advanced Settings", add `--`, `-r`, and `example.tk` to "Container arguments", replacing "example.tk" with your domain.
    * In the next section, change "Ingress" to "Allow internal traffic only" and "Authentication" to "Require authentication".
    * Click "Create".
    * Make note of the Service URL.
6) Go to [Cloud Source Triggers](https://console.cloud.google.com/cloud-build/triggers).
    * Next to "Run", click the Kebab Menu (three dots), then "Edit".
    * Under "Configuration", change "Location" to "Repository".
    * Under "Advanced", add two variables.
        * These should be called "_FREENOM_EMAIL" and "_FREENOM_PASSWORD". Set their values to your freenom email and password, respectively.
    * Click "Save".
    * Click on "Run", then "Run Trigger" to build the docker image with your credentials.
7) Go to [Cloud Scheduler](https://console.cloud.google.com/cloudscheduler).
    * Click on "Schedule a Job".
    * Leave the location as default, as long as you prefer it.
    * Name the job "freenom".
    * Under frequency, enter `0 0 */10 * *`. This will run 3 times per month, which is within [Cloud Scheduler's Free Tier](https://cloud.google.com/scheduler/pricing).
        * This is a cron schedule expression. [Crontab Guru](https://crontab.guru/#0_0_*/10_*_*) can be used to preview them.
    * Under "Timezone", type your Country, then select your preferred time zone.
    * In the next section, change "Target type" to "HTTP".
    * Change "HTTP method" to "GET".
    * Change the URL to the Service URL from step 5.
    * Change "Auth header" to "Add OIDC token".
    * Change "Service account" to the Service Account Email from step 3.
    * Click "Continue", then "Create".
8) You're done! Check on the [Logs](https://console.cloud.google.com/logs) to see if everything is working.
    * Note that if it shows an error as "GET 500", that probably means the domain cannot be renewed at this time.
