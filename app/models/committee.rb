class Committee < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :name

  has_many :committee_memberships, dependent: :destroy
  has_many :representatives, through: :committee_memberships
  has_many :parliament_issues, order: 'last_update DESC'

  validates_uniqueness_of :name # :external_id

  friendly_id :external_id, use: :slugged

  def current_representatives
    representatives_at Date.today
  end

  def representatives_at(date)
    committee_memberships.includes(:representative).for_date(date).map { |e| e.representative }
  end
end
