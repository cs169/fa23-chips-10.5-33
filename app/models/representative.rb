# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  def self.create_representative(official, office_title, ocdid)
    data = self.representative_data(official, office_title, ocdid)
    Representative.find_or_create_by(data)
  end

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

      rep = create_representative(official, title_temp, ocdid_temp)
      reps.push(rep)
    end

    return reps
  end

  def self.representative_data(official, office_title, ocdid)
    if official.address
      {
      name: official.name || '',
      title: office_title,
      ocdid: ocdid,
      street: "#{official.address[0].line1}",
      city: "#{official.address[0].city}",
      state: "#{official.address[0].state}",
      zip: "#{official.address[0].zip}",
      party: official.party,
      photo_url: official.photo_url
      }
    else
      {
      name: official.name || '',
      title: office_title,
      ocdid: ocdid,
      street: "",
      city: "",
      state: "",
      zip: "",
      party: official.party,
      photo_url: official.photo_url
      }
    end
  end

end
