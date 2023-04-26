.mode csv
.import pokemon.csv imported_pokemon_data

-- split apart the abilities column values and store in new table
CREATE TABLE split_abilities AS
SELECT pokedex_number, abilities, trim(value) AS split_value
FROM imported_pokemon_data,
json_each('["' || replace(abilities, ',', '","') || '"]')
WHERE split_value <> '';

-- Removes square brakets and single quotes from data
UPDATE split_abilities
SET split_value = REPLACE(
                  REPLACE(
                  REPLACE(split_value, '[', ''),
                  '''', ''),
                  ']', '')
WHERE split_value LIKE '[%'
   OR split_value LIKE '%]'
   OR split_value LIKE '''%'
   OR split_value LIKE '%''';

-- Updates table with new values
UPDATE imported_pokemon_data
SET abilities = (SELECT split_value
FROM split_abilities
WHERE imported_pokemon_data.pokedex_number = split_abilities.pokedex_number);
