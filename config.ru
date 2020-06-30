# frozen_string_literal: true

require_relative './lib/journeyviz'

Journeyviz.configure do |journey|
  journey.block :intent do |block|
    block.screen :landing_pages do |screen|
      screen.action :click_simulation_form, transition: :request_form
    end

    block.screen :request_form do |screen|
      screen.action :in_target_simulation, transition: %i[offering proof_of_revenue]
      screen.action :out_of_target_simulation, transition: %i[recovery additional_info]
    end
  end

  journey.block :offering do |block|
    block.screen :proof_of_revenue do |screen|
      %i[
        send_salary_stub send_benefit_stub gave_sigepe_access
        gave_meu_inss_access
      ].each do |action|
        screen.action action, transition: :loading
      end
      screen.action :send_bad_proof_of_revenue, transition: :failure
    end

    block.screen :failure do |screen|
      screen.action :try_again, transition: :proof_of_revenue
    end

    block.screen :loading do |screen|
      screen.action :found_offer, transition: :offer
      screen.action :no_offers, transition: %i[recovery additional_info]
    end

    block.screen :offer do |screen|
      screen.action :select_offer, transition: %i[formalization additional_data]
      screen.action :select_bb_offer, transition: %i[formalization deep bb]
    end
  end

  journey.block :formalization do |block|
    block.screen :a do |screen|
      screen.action :foobar, transition: %i[formalization deep bb]
    end

    block.block :deep do |deep|
      deep.screen :bb
    end

    block.screen :additional_data do |screen|
      screen.action :submit, transition: :documents
    end

    block.screen :documents do |screen|
      screen.action :send_document
      screen.action :send_all_documents, transition: :contract_signature
    end

    block.screen :contract_signature do |screen|
      screen.action :sign, transition: %i[delivery_control status]
    end
  end

  journey.block :delivery_control do |block|
    block.screen :status do |screen|
      screen.action :proof_of_revenue_followup, transition: %i[offering proof_of_revenue]
      screen.action :offer_followup, transition: %i[offering offer]
      screen.action :additional_data_followup, transition: %i[formalization additional_data]
      screen.action :documents_followup, transition: %i[formalization documents]
      screen.action :contract_signature_followup, transition: %i[formalization contract_signature]
      screen.action :recovery_followup, transition: %i[recovery additional_info]
    end
  end

  journey.block :recovery do |block|
    block.screen :additional_info
  end
end

run Journeyviz::Server
