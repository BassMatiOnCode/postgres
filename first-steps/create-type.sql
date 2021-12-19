CREATE TYPE field_update_info AS (
	name text,
	original any,
	proposed any,
	current any
	) ;