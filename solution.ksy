meta:
  id: exapunks_solution
  file-extension: solution
  endian: le
seq:
  - id: version
    type: u4
  - id: file_id
    type: pstr
  - id: name
    type: pstr
  - id: competition_wins
    type: u4
  - id: redshift_program_size
    type: u4
  - id: win_stats_count
    type: u4
  - id: win_stats
    type: win_value_pair
    repeat: expr
    repeat-expr: win_stats_count
  - id: exa_instances_count
    type: u4
  - id: exa_instances
    type: exa_instance
    repeat: expr
    repeat-expr: exa_instances_count
types:
  pstr:
    seq:
      - id: length
        type: u4
      - id: string
        type: str
        encoding: ASCII
        size: length
  win_value_pair:
    seq:
      - id: type
        type: u4
        enum: win_value_type
      - id: value
        type: u4
  exa_instance:
    seq:
      - contents: [0xA]
      - id: name
        type: pstr
      - id: code
        type: pstr
      - id: editor_display_status
        type: u1
        enum: editor_display_status
      - id: memory_scope
        type: u1
        enum: memory_scope
      - id: bitmap
        size: 100
enums:
  win_value_type:
    0: cycles
    1: size
    2: activity
  editor_display_status:
    0: unrolled
    1: collapsed
  memory_scope:
    0: global
    1: local