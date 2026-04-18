# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"
require "securerandom"

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

module WfTestFactory
  def unique_name(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def create_user(name_prefix: "user", group: nil)
    Wf::User.create!(name: unique_name(name_prefix), group: group)
  end

  def create_group(name_prefix: "group")
    Wf::Group.create!(name: unique_name(name_prefix))
  end

  def create_form(name_prefix: "form")
    Wf::Form.create!(name: unique_name(name_prefix))
  end

  def create_workflow(name_prefix: "workflow")
    Wf::Workflow.create!(name: unique_name(name_prefix))
  end

  def build_linear_workflow(trigger_type: :user, with_form: false)
    workflow = create_workflow
    start_place = workflow.places.create!(name: unique_name("start"), place_type: :start)
    end_place = workflow.places.create!(name: unique_name("end"), place_type: :end)
    transition_params = { name: unique_name("transition"), trigger_type: trigger_type }
    transition_params[:form] = create_form(name_prefix: "transition-form") if with_form
    transition = workflow.transitions.create!(transition_params)
    in_arc = workflow.arcs.create!(transition: transition, place: start_place, direction: :in)
    out_arc = workflow.arcs.create!(transition: transition, place: end_place, direction: :out)

    {
      workflow: workflow,
      start_place: start_place,
      end_place: end_place,
      transition: transition,
      in_arc: in_arc,
      out_arc: out_arc
    }
  end

  def create_case_with_workitem(trigger_type: :user, workitem_state: :enabled)
    flow = build_linear_workflow(trigger_type: trigger_type)
    wf_case = flow[:workflow].cases.create!(state: :active)
    workitem = flow[:workflow].workitems.create!(case: wf_case, transition: flow[:transition], state: workitem_state)

    flow.merge(wf_case: wf_case, workitem: workitem)
  end
end

ActiveSupport::TestCase.include(WfTestFactory)
ActionDispatch::IntegrationTest.include(WfTestFactory)
