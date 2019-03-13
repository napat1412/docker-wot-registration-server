CREATE TABLE __diesel_schema_migrations (version VARCHAR(50) PRIMARY KEY NOT NULL,run_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE accounts (
    id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE, optout BOOLEAN NOT NULL DEFAULT FALSE);
CREATE UNIQUE INDEX accounts_email ON accounts(email);
CREATE TABLE domains (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name               VARCHAR(253) NOT NULL UNIQUE,
    account_id         INTEGER NOT NULL,
    token              VARCHAR(36) NOT NULL,
    description        TEXT NOT NULL,
    timestamp          BIGINT NOT NULL,
    dns_challenge      VARCHAR(63) NOT NULL DEFAULT '',
    reclamation_token  VARCHAR(36) NOT NULL DEFAULT '',
    verification_token VARCHAR(36) NOT NULL DEFAULT '',
    verified           BOOLEAN NOT NULL DEFAULT FALSE, continent VARCHAR(2) NOT NULL DEFAULT '',
    FOREIGN KEY(account_id) REFERENCES accounts(id) ON UPDATE CASCADE ON DELETE CASCADE);
CREATE UNIQUE INDEX domains_name ON domains(name);
CREATE INDEX domains_timestamp ON domains(timestamp);
CREATE INDEX domains_account_id ON domains(account_id);
