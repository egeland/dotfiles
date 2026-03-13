if status is-interactive
    abbr -a -- gs 'git status'
    abbr -a -- gd 'git diff'

    # Cloud SQL proxy shortcuts — connection strings loaded from ~/.env
    # Set DB_STG, DB_QA, DB_PROD in ~/.env
    if set -q DB_STG
        abbr -a -- db-stg "cloud-sql-proxy $DB_STG"
    end
    if set -q DB_QA
        abbr -a -- db-qa "cloud-sql-proxy $DB_QA"
    end
    if set -q DB_PROD
        abbr -a -- db-prod "cloud-sql-proxy $DB_PROD"
    end
end
