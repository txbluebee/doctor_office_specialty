class Doctor

  attr_accessor(:id, :name, :specialty_name)

  def initialize(attributes)
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
    @specialty_name = attributes.fetch(:specialty_name)
  end

  def ==(another_doctor)
    (self.id() == another_doctor.id()) && (self.name() == another_doctor.name()) && (self.specialty_name() == another_doctor.specialty_name())
  end

  def self.all
    all_doctors = DB.exec("SELECT * FROM doctors;")
    saved_doctors = []
    all_doctors.each() do |doctor|
      id = doctor.fetch('id').to_i()
      name = doctor.fetch('name')
      specialty_name = doctor.fetch('specialty_name')
      saved_doctors.push(Doctor.new({:id => id, :name => name, :specialty_name => specialty_name}))
    end
    saved_doctors
  end

  def save
    result = DB.exec("INSERT INTO doctors (name, specialty_name) VALUES ('#{@name}', '#{@specialty_name}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  def self.find(id)
    found_doctor = nil
    Doctor.all().each() do |doctor|
      if doctor.id() == id
      found_doctor = doctor
      end
    end
    found_doctor
  end

  def patients
    doctor_patients = []
    patients = DB.exec("SELECT * FROM patients WHERE doctor_id = #{self.id()};")
    patients.each() do |patient|
      name = patient.fetch('name')
      birthdate = patient.fetch('birthdate')
      doctor_id = patient.fetch('doctor_id').to_i()
      doctor_patients.push(Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id}))
    end
    doctor_patients
  end

end