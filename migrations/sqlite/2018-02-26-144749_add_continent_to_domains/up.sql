ALTER TABLE domains ADD COLUMN continent VARCHAR(6) NOT NULL DEFAULT '';
UPDATE domains SET continent = 'NA' WHERE continent = '';
