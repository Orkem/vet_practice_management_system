require_relative('../models/appointment')

get '/appointments' do
  @appointments = Appointment.get_all
  erb(:'appointments/index')
end