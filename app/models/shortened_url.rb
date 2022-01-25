# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
    validates :long_url, presence: true
    validates :short_url, presence: true, uniqueness: true
    validates :user_id, presence: true

    belongs_to :submitter,
        primary_key: :id,
        foreign_key: :user_id
        class_name: :User

    def self.random_code
        rand = SecureRandom.urlsafe_base64(16)
        return random_code unless ShortenedUrl.exists?(short_url: random_code)
    end

    def self.create_with_user_and_long_url!(user,long_url)
        ShortenedUrl.create!(
            user_id: user.id,
            long_url: long_url,
            short_url: ShortenedUrl.random_code
        )
    end
end
