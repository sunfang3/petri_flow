# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2020_02_26_195134) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pg_catalog.plpgsql"

  create_table "entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "form_id"
    t.json "payload"
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.bigint "workitem_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
    t.index ["workitem_id", "user_id"], name: "index_entries_on_workitem_id_and_user_id", unique: true
    t.index ["workitem_id"], name: "index_entries_on_workitem_id"
  end

  create_table "field_values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "entry_id"
    t.bigint "field_id"
    t.bigint "form_id"
    t.datetime "updated_at", null: false
    t.text "value"
  end

  create_table "fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "default_value"
    t.integer "field_type", default: 0
    t.string "field_type_name"
    t.bigint "form_id"
    t.string "name"
    t.integer "position", default: 0
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_fields_on_form_id"
  end

  create_table "forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "wf_arcs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "direction", default: 0, comment: "0-in, 1-out"
    t.integer "guards_count", default: 0
    t.bigint "place_id"
    t.bigint "transition_id"
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
  end

  create_table "wf_case_assignments", comment: "Manual per-case assignments of transition to parties", force: :cascade do |t|
    t.bigint "case_id"
    t.datetime "created_at", null: false
    t.bigint "party_id"
    t.bigint "transition_id"
    t.datetime "updated_at", null: false
    t.index ["case_id", "transition_id", "party_id"], name: "wf_ctp_u", unique: true
  end

  create_table "wf_cases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "started_by_workitem_id", comment: "As a sub workflow instance, it is started by one workitem."
    t.integer "state", default: 0, comment: "0-created, 1-active, 2-suspended, 3-canceled, 4-finished"
    t.string "targetable_id", comment: "point to target ID of Application."
    t.string "targetable_type", comment: "point to target type of Application."
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
  end

  create_table "wf_comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.bigint "workitem_id"
    t.index ["user_id"], name: "index_wf_comments_on_user_id"
    t.index ["workitem_id"], name: "index_wf_comments_on_workitem_id"
  end

  create_table "wf_demo_targets", comment: "For demo, useless.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "wf_entries", comment: "user input data for workitem with form.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "form_id"
    t.json "payload", default: {}
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.bigint "workitem_id"
    t.index ["user_id"], name: "index_wf_entries_on_user_id"
    t.index ["workitem_id", "user_id"], name: "index_wf_entries_on_workitem_id_and_user_id", unique: true
    t.index ["workitem_id"], name: "index_wf_entries_on_workitem_id"
  end

  create_table "wf_field_values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "entry_id"
    t.bigint "field_id"
    t.bigint "form_id"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["field_id"], name: "index_wf_field_values_on_field_id"
    t.index ["form_id"], name: "index_wf_field_values_on_form_id"
  end

  create_table "wf_fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "default_value"
    t.integer "field_type", default: 0
    t.string "field_type_name"
    t.bigint "form_id"
    t.string "name"
    t.integer "position", default: 0
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_wf_fields_on_form_id"
  end

  create_table "wf_forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "wf_groups", comment: "For demo", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "wf_guards", force: :cascade do |t|
    t.bigint "arc_id"
    t.datetime "created_at", null: false
    t.string "exp"
    t.string "fieldable_id"
    t.string "fieldable_type"
    t.string "op"
    t.datetime "updated_at", null: false
    t.string "value"
    t.bigint "workflow_id"
    t.index ["arc_id"], name: "index_wf_guards_on_arc_id"
    t.index ["workflow_id"], name: "index_wf_guards_on_workflow_id"
  end

  create_table "wf_parties", comment: "for groups or roles or users or positions etc.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "partable_id"
    t.string "partable_type"
    t.string "party_name"
    t.datetime "updated_at", null: false
    t.index ["partable_type", "partable_id"], name: "index_wf_parties_on_partable_type_and_partable_id", unique: true
  end

  create_table "wf_places", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "place_type", default: 0, comment: "类型：0-start，1-normal，2-end"
    t.integer "sort_order", default: 0
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
  end

  create_table "wf_tokens", force: :cascade do |t|
    t.datetime "canceled_at", precision: nil
    t.bigint "case_id"
    t.datetime "consumed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "locked_at", precision: nil
    t.bigint "locked_workitem_id"
    t.bigint "place_id"
    t.datetime "produced_at", precision: nil, default: -> { "timezone('utc'::text, now())" }
    t.integer "state", default: 0, comment: "0-free, 1-locked, 2-canceled, 3-consumed"
    t.string "targetable_id"
    t.string "targetable_type"
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
  end

  create_table "wf_transition_static_assignments", comment: "pre assignment for transition", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "party_id"
    t.bigint "transition_id"
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
    t.index ["transition_id", "party_id"], name: "wf_tp_u", unique: true
  end

  create_table "wf_transitions", force: :cascade do |t|
    t.string "assignment_callback", default: "Wf::Callbacks::AssignmentDefault"
    t.datetime "created_at", null: false
    t.string "deadline_callback", default: "Wf::Callbacks::DeadlineDefault"
    t.text "description"
    t.bigint "dynamic_assign_by_id", comment: "dynamic assign by other transition"
    t.string "enable_callback", default: "Wf::Callbacks::EnableDefault"
    t.string "finish_condition", default: "Wf::MultipleInstances::AllFinish", comment: "set finish condition for parent workitem."
    t.string "fire_callback", default: "Wf::Callbacks::FireDefault"
    t.bigint "form_id"
    t.string "form_type", default: "Wf::Form"
    t.string "hold_timeout_callback", default: "Wf::Callbacks::HoldTimeoutDefault"
    t.boolean "multiple_instance", default: false, comment: "multiple instance mode or not"
    t.string "name"
    t.string "notification_callback", default: "Wf::Callbacks::NotificationDefault"
    t.integer "sort_order", default: 0
    t.bigint "sub_workflow_id"
    t.string "time_callback", default: "Wf::Callbacks::TimeDefault"
    t.integer "trigger_limit", comment: "use with timed trigger, after x minitues, trigger exec"
    t.integer "trigger_type", default: 0, comment: "0-user,1-automatic, 2-message,3-time"
    t.string "unassignment_callback", default: "Wf::Callbacks::UnassignmentDefault"
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
    t.index ["form_type", "form_id"], name: "index_wf_transitions_on_form_type_and_form_id"
  end

  create_table "wf_users", comment: "For demo", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "group_id"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "wf_workflows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "creator_id"
    t.text "description"
    t.text "error_msg"
    t.boolean "is_valid", default: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "wf_workitem_assignments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "party_id"
    t.datetime "updated_at", null: false
    t.bigint "workitem_id"
    t.index ["workitem_id", "party_id"], name: "wf_wp_u", unique: true
  end

  create_table "wf_workitems", force: :cascade do |t|
    t.datetime "canceled_at", precision: nil
    t.bigint "case_id"
    t.integer "children_count", default: 0
    t.integer "children_finished_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "deadline", precision: nil
    t.datetime "enabled_at", precision: nil, default: -> { "timezone('utc'::text, now())" }
    t.datetime "finished_at", precision: nil
    t.boolean "forked", default: false
    t.string "holding_user_id", comment: "id of App user"
    t.datetime "overridden_at", precision: nil
    t.bigint "parent_id", comment: "parent workitem id"
    t.datetime "started_at", precision: nil
    t.integer "state", default: 0, comment: "0-enabled, 1-started, 2-canceled, 3-finished,4-overridden"
    t.bigint "transition_id"
    t.datetime "trigger_time", precision: nil, comment: "set when transition_trigger=TIME & trigger_limit present"
    t.datetime "updated_at", null: false
    t.bigint "workflow_id"
    t.index ["state", "trigger_time"], name: "index_wf_workitems_on_state_and_trigger_time"
  end
end
