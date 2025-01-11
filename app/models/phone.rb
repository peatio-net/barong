# frozen_string_literal: true

#
# Class Phone
#
class Phone < ApplicationRecord
  include Encryptable

  TWILIO_CHANNELS = %w[call sms].freeze
  DEFAULT_COUNTRY_CODE_COUNT = 2
  MAX_PHONES_PER_USER = 20

  belongs_to :user

  attr_encrypted :number
  validates :number, phone: true

  before_create :generate_code
  before_validation :parse_country
  before_validation :sanitize_number

  before_save :save_number_index

  validate :validate_phone_count

  scope :verified, -> { where.not(validated_at: nil) }
  scope :unverified, -> { where(validated_at: nil) }


  #FIXME: Clean code below
  class << self
    def sanitize(unsafe_phone)
      unsafe_phone.to_s.gsub(/\D/, '')
    end

    def parse(unsafe_phone)
      Phonelib.parse self.sanitize(unsafe_phone)
    end

    def valid?(unsafe_phone)
      parse(unsafe_phone).valid?
    end

    def international(unsafe_phone)
      parse(unsafe_phone).international(false)
    end

    def find_by_number(number, attrs={})
      number = self.sanitize(number)
      attrs.merge!(number_index: SaltedCrc32.generate_hash(number))
      Rails.logger.warn "attrs : #{attrs}"
      Rails.logger.warn "number : #{number}"
      find_by(attrs)
    end

    def find_by_number!(number)
      find_by!(number_index: SaltedCrc32.generate_hash(number))
    end
  end

  def validate_phone_count
    errors.add(:user_id, 'reached maximum number of phones') if user.phones.count > MAX_PHONES_PER_USER
  end

  def sub_masked_number
    code_count = parse_code&.length
    code_count = DEFAULT_COUNTRY_CODE_COUNT unless code_count

    if number.present?
      number.sub(/(?<=\A.{#{code_count}})(.*)(?=.{4}\z)/) { |match| '*' * match.length }
    else
      number
    end
  end

  private

  def generate_code
    self.code = rand.to_s[2..6]
  end

  def parse_country
    data = Phonelib.parse(number)
    self.country = data.country
  end

  def parse_code
    data = Phonelib.parse(number)
    data.country_code
  end

  def sanitize_number
    self.number = Phone.sanitize(number)
  end

  def save_number_index
    if number.present?
      self.number_index = SaltedCrc32.generate_hash(number)
    end
  end
end

# == Schema Information
# Schema version: 20211019200925
#
# Table name: phones
#
#  id               :bigint           not null, primary key
#  user_id          :integer          unsigned, not null
#  country          :string(255)      not null
#  code             :string(5)
#  number_encrypted :string(255)      not null
#  number_index     :bigint           not null
#  validated_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  retries_send     :integer          default(0), not null
#  retries_verify   :integer          default(0), not null
#
# Indexes
#
#  index_phones_on_number_index  (number_index)
#  index_phones_on_user_id       (user_id)
#
