include: "//block-jira-config/issue.view"

view: issue {
  extends: [issue_config]
}

view: issue_core {
  extension: required
  sql_table_name: @{SCHEMA_NAME}.issue ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: external_issue_id {
    type: string
    sql: ${TABLE}.external_issue_id ;;
  }

  dimension: _original_estimate {
    type: number
    sql: ${TABLE}._original_estimate ;;
  }

  dimension: _remaining_estimate {
    type: number
    sql: ${TABLE}._remaining_estimate ;;
  }

  dimension: _time_spent {
    type: number
    sql: ${TABLE}._time_spent ;;
  }

  dimension: assignee {
    type: string
    sql: ${TABLE}.assignee ;;
  }

  dimension_group: created {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created ;;
  }

  dimension: department {
    hidden: yes
    type: number
    sql: ${TABLE}.op_department ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension_group: due {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.due_date ;;
  }

  dimension: environment {
    type: string
    sql: ${TABLE}.environment ;;
  }

  dimension: issue_type {
    hidden: yes
    type: number
    sql: ${TABLE}.issue_type ;;
  }

  dimension: original_estimate {
    type: number
    sql: ${TABLE}.original_estimate ;;
  }

  dimension: priority {
    type: number
    hidden: yes
    sql: ${TABLE}.priority ;;
  }

  dimension: project {
    label: "Current Project"
    hidden: yes
    type: number
    sql: ${TABLE}.project ;;
  }

  dimension: resolution {
    group_label: "Resolution"
    hidden: yes
    type: number
    sql: ${TABLE}.resolution ;;
  }

  dimension_group: resolved {
    group_label: "Resolution"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.resolved ;;
  }

  # Additional field for a simple way to determine
  # if an issue is resolved
  dimension: is_issue_resolved {
    group_label: "Resolution"
    type: yesno
    sql: ${resolved_date} IS NOT NULL ;;
  }

  # Custom dimensions for time to resolve issue
  dimension: hours_to_resolve_issue {
    group_label: "Resolution"
    label: "Time to Resolve (Hours)"
    type: number
    sql: timestamp_diff(${resolved_raw}, ${created_raw}, hour) ;;
    value_format_name: decimal_0
  }

  dimension: minutes_to_resolve_issue {
    group_label: "Resolution"
    label: "Time to Resolve (Minutes)"
    type: number
    sql: timestamp_diff(${resolved_raw}, ${created_raw}, minute) ;;
    value_format_name: decimal_0
  }

  dimension: days_to_resolve_issue {
    group_label: "Resolution"
    label: "Time to Resolve (Days)"
    type: number
    sql: timestamp_diff(${resolved_raw}, ${created_raw}, day) ;;
    value_format_name: decimal_0
  }

  measure: total_days_to_resolve_issues_hours {
    group_label: "Resolution"
    label: "Total Days to Resolve Issues"
    description: "The total hours required to resolve all issues in the chosen dimension grouping"
    type: sum
    sql: ${days_to_resolve_issue} ;;
    value_format_name: decimal_0
  }

  measure: avg_days_to_resolve_issues_hours {
    group_label: "Resolution"
    label: "Avg Number of Days to Resolve Issues"
    description: "The average hours required to resolve all issues in the chosen dimension grouping"
    type: average
    sql: ${days_to_resolve_issue} ;;
    value_format_name: decimal_0
  }

  dimension: severity {
    hidden: yes
    type: number
    sql: ${TABLE}.severity ;;
  }

  dimension: status {
    hidden: yes
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: story_points {
    type: number
    sql: ${TABLE}.story_points ;;
  }

  measure: total_story_points {
    type: sum
    sql: ${story_points} ;;
  }

  dimension_group: updated {
    group_label: "Dates"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated ;;
  }

  measure: count {
    type: count
    drill_fields: [id, days_to_resolve_issue, created_date, severity ]
  }

  # ----- Sets of fields for drilling ------
  #set: detail {
  #  fields: [
  #    external_issue_id,
  #  ]
  #}

}