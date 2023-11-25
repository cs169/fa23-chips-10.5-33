# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.civic_api_to_representative_params(rep_info)
    reps = []

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end

      # rep = Representative.create!({ name: official.name, ocdid: ocdid_temp,
      #     title: title_temp })
      # reps.push(rep)

      # rep = Representative.find_or_initialize_by(name: official.name, ocdid: ocdid_temp, title: title_temp)
      rep = Representative.find_or_initialize_by(name: official.name, ocdid: ocdid_temp, title: title_temp)
      # rep.assign_attributes(name: official.name, title: title_temp)
      rep.save
      reps.push(rep)
    end

    reps
  end
end
