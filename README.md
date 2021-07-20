# drupal_core_release
Set of scripts for preparing a Drupal core release.

- `tag.sh`: Tags a core release
- `sec.sh`: Creates a core security release
- `branch.sh`: Creates a new core branch for a new minor version
- `posts.sh`: Generates post text for various release announcements.
- `generate_queries.sh`: (deprecated) Generate SQL queries for release notes. Use the [core metrics sandbox](https://www.drupal.org/sandbox/xjm/core_metrics) instead.

Usage
=====

Release tagging script: `tag.sh`
----------------------------------

See https://www.drupal.org/core/maintainers/create-core-release for complete
instructions on creating core releases. Use at your own risk!

Requires:
- drush
- https://www.drupal.org/project/grn

Execute this script from your local git repository, either by adding it to your
path or by using the full path to the script.

1. Check out the correct branch and ensure you have the latest changes:

   `git checkout 8.1.x; git pull`

2. Run the script:

   `/path/to/core_release/tag.sh`

   You will be prompted to enter the release number, as well as the previous and
   next release numbers if it is not a normal patch release,
   
3. Your drush rn output will be copied to the clipboard if you have pbcopy
   (Mac), or output directly otherwise. Add it to your release notes.

4. Make sure the script did the right things:

   `git show`
   
   `git log`

5. Push your tags and commits manually using the command the script displays. The
   command includes a `sleep` to avoid a race condition on packaging, so expect it
   to sit doing nothing for a bit.

Security release script: `sec.sh`
----------------------------------

See https://www.drupal.org/core/maintainers/create-core-security-release for
complete instructions on creating security releases. Only create security
releases in collaboration with the security team and do not share any
information (including whetherthere will be a release) outside the security
team. (See the
[security team disclosure policy](https://www.drupal.org/drupal-security-team/security-team-procedures/drupal-security-team-disclosure-policy-for-security)
for more information.)

Execute this script from your local git clone of Drupal core, either by
adding it to your system path or by using the full path to the script.

1. Check out the correct branch(es) and ensure you have the latest changes:

   `git checkout 8.1.x; git pull`
   
2. Run the script, with the tag(s) to create as arguments:

   `/path/to/core_release/manual_merge_sec.sh 8.6.4 8.5.9`

   You will be prompted to enter information about the SA and the path(s) to patches for each branch. You can tag D7 and D8 releases at the same time with a single command.

3. Make sure the script did the right things:

   `git show`

   `git log`
   
   `git diff 8.1.6 8.1.7`
   
4. Only push your tags and commits using the command the script displays, and
    only after you have approval from the security team.

Security release with manual merge conflict resolution: `manual_merge_sec.sh` and `conclude_merge.sh`
-----------------------------------------------------------------------------
1. Check out the correct branch(es) and ensure you have the latest changes:

   `git checkout 9.1.x; git pull`

2. Run the script, with the tag(s) to create as arguments:

   `/path/to/core_release/sec.sh 9.1.3 9.0.11 8.9.13`

   The script will prompt you for information about the SA, then apply the
   patches and create working branches. It will stop before merging the tags
   and output instructions for merging the tags manually.

3. Follow the instructions to merge the tags after reviewing
   [how to manually resolve the expected merge conflicts](https://www.drupal.org/core/maintainers/create-core-security-release/dep-update#release).

4. Run `/path/to/cor_release/conclude_merge.sh`.

5. Make sure the script did the right things:

   `git show`

   `git log`

   `git diff 9.1.3 9.1.2`

6. Only push your tags and commits using the command the script displays, and
    only after you have approval from the security team.


Core branching script: `branch.sh`
----------------------------------

1. Follow the prompts.
2. Manually push the new branch once it is created.
3. Be sure to configure automated testing.
4. Ask drumm to run any needed issue migrations and to update api.d.o.

(Deprecated) Post generation script: `posts.sh`
----------------------------------

With each command, markup for the post is printed to `stdout` and copied to the clipboard with `pbcopy`.

`-r` Generate release notes.

`-f` Generate frontpage post.

`-s` Security window instead of a patch window.

`-m` Minor release, beta, or RC instead of a patch window.

### Release notes (Drupal 8 only)

The release notes automatically incorporate lists of issues in `rn_issues.txt` if it is available. To generate this with the [Core issue metrics sandbox](https://www.drupal.org/sandbox/xjm/core_metrics) sandbox:

1. Update `src/triage/QueryBuilder.php` in the metrics project as needed.
2. Execute the query set on staging:
   `bash build_run_queries.sh core_release`
3. Run the PHP script provided in the core metrics project to build the release notes and place it within the root of this project:
   `php /path/to/core_metrics/core_release/core_release.php > ./rn_issues.txt`

#### `./posts.sh -r`

Generate a template for the release notes for the patch release (Drupal 8 only). You will be prompted to enter the release number for Drupal 8.

#### `./posts.sh -r -s`

Generate a template for the release notes for a security release. The template is the same for all versions.

#### `./posts.sh -r -m`

Generate a template for the release notes of a minor release, beta, or release candidate (Drupal 8 only). You will be prompted to enter the release number for Drupal 8. For betas and RCs, enter the minor version number only (e.g. '8.1.0' for 8.1.0-beta1).

### Release announcements for the Drupal.org frontpage

Post these announcements after the releases are created.

#### `./posts.sh -f`

Generate a frontpage announcement for https://www.drupal.org about the patch release. You will be promped to enter the release number for Drupal 8 (required) and Drupal 7 (optional).

#### `./posts.sh -f -s`

Generate a frontpage announcement for https://www.drupal.org about the security release. You will be promped to enter the release number for Drupal 8 (required) and Drupal 7 (optional).

(Deprecated) Release note query generation script: `generate_queries.sh`
------------------------------------------------------------------------

This script generates SQL queries against the Drupal.org database to fetch lists of issues for the release notes. You will be prompted to enter the D8 version number. The generated queries are printed to `stdout` and copied to the clipboard.

You can also use the [Core issue metrics sandbox](https://www.drupal.org/sandbox/xjm/core_metrics) to generate these queries and fetch their data (or ask xjm).

