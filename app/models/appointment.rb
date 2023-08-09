class Appointment < ApplicationRecord
  belongs_to :dentist
  belongs_to :patient

  attribute :date, :date
  attribute :time, :time

  before_validation :date_not_in_past, :valid_date

  validates :date, presence: true
  validates :time, presence: true

  validate :appointment_not_conflicting

  private

  def date_not_in_past
    if date.present? && date < Time.zone.today
      errors.add(:date, "não pode ser marcada no passado")
    end
  end

  def valid_date
    if date.present? && time.present? && DateTime.parse("#{date} #{time}") < Time.zone.now
      errors.add(:date, "horário já passou")
    end
  end

  def appointment_not_conflicting
    if dentist.appointments.where(date: date, time: time).exists?
      errors.add(:base, "Horário já ocupado por outra consulta.")
    end
  end
end
