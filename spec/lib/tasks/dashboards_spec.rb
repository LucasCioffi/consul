require "rails_helper"
require "rake"

describe "Dashboards Rake" do

  describe "#send_notifications" do

    before do
      Rake.application.rake_require "tasks/dashboards"
      Rake::Task.define_task(:environment)
      Setting["dashboard.emails"] = true
      ActionMailer::Base.deliveries.clear
    end

    after do
      Setting["dashboard.emails"] = nil
    end

    let :run_rake_task do
      Rake::Task["dashboards:send_notifications"].reenable
      Rake.application.invoke_task "dashboards:send_notifications"
    end

    describe "Not send notifications to proposal author" do

      let!(:action)   { create(:dashboard_action, :proposed_action, :active, day_offset: 1) }
      let!(:resource) { create(:dashboard_action, :resource, :active, day_offset: 1) }

      it "when there are not news actions actived for published proposals" do
        create(:proposal)
        action.update(published_proposal: true)
        resource.update(published_proposal: true)

        expect {run_rake_task}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

      it "when there are not news actions actived for draft proposals" do
        create(:proposal, :draft)
        action.update(published_proposal: false)
        resource.update(published_proposal: false)

        expect {run_rake_task}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

      it "when there are news actions actived for archived proposals" do
        create(:proposal, :archived)
        action.update(day_offset: 0, published_proposal: true)
        resource.update(day_offset: 0, published_proposal: true)

        expect {run_rake_task}.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

    end

    describe "Send notifications to proposal author" do
      let!(:action)   { create(:dashboard_action, :proposed_action, :active, day_offset: 0) }
      let!(:resource) { create(:dashboard_action, :resource, :active, day_offset: 0) }

      it " when there are news actions actived for published proposals" do
        proposal = create(:proposal)
        action.update(published_proposal: true)
        resource.update(published_proposal: true)

        run_rake_task
        email = open_last_email

        expect(email).to deliver_from("Lucas Cioffi for Town Supervisor <hello@greenburgh.us>")
        expect(email).to deliver_to(proposal.author)
        expect(email).to have_subject("More news about your citizen proposal")
      end

      it "when there are news actions actived for draft proposals" do
        proposal = create(:proposal, :draft)
        action.update(published_proposal: false)
        resource.update(published_proposal: false)

        run_rake_task
        email = open_last_email

        expect(email).to deliver_from("Lucas Cioffi for Town Supervisor <hello@greenburgh.us>")
        expect(email).to deliver_to(proposal.author)
        expect(email).to have_subject("More news about your citizen proposal")
      end
    end

  end

end
