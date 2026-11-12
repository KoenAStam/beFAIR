# Add a stable `participant_id` to an ID mapping table

Creates a deterministic participant identifier derived from `study_id`
and `participant_nr`.

## Usage

``` r
.addParticipantIds(id_mapping)
```

## Arguments

- id_mapping:

  A data frame with columns `source_id`, `study_id`, and
  `participant_nr` (integer).

## Value

A data.frame with columns `source_id`, `study_id`, `participant_nr`, and
`participant_id`.

## Details

The identifier is constructed by concatenating `study_id` and a
zero-padded (4-digit) `participant_nr`, hashing the key with SHA-256,
and taking the first six hexadecimal characters. Final form:
`"<study_id>_<hash6>"`.

Multiple `source_id` values may map to the same participant when they
share the same `study_id` and `participant_nr`. Hash truncation means
collisions are theoretically possible but very unlikely.
