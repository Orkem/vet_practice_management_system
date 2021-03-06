require_relative('../models/appointment')
require_relative('../models/appointment_time')
require_relative('../models/date')

# index
get '/appointments' do
  #check if arrived button clicked then timestamp
  if params['submit'] == "Arrived"
    @appointment = Appointment.find(params['appointment'])
    @appointment.set_arrival
  #check complete button submitted  
  elsif params['complete_appointment']
    @appointment = Appointment.find(params['complete_appointment'])
    @appointment.complete  
  end

  #check param[date] is set then get next  or prev appointments
  if params['next_date']
    @current_date = ApDate.next_day(params['next_date'])
    @appointments = ApDate.get_date_apps(@current_date)
  elsif params['prev_date']
    @current_date = ApDate.prev_day(params['prev_date'])
    @appointments = ApDate.get_date_apps(@current_date)    
  else
    @current_date = ApDate.get_todays_date
    @appointments = ApDate.get_date_apps
  end

  if @current_date.to_s == ApDate.get_todays_date.to_s
    @date_title = "Todays Appointments"
  else
    @date_title = "Appointments on " + @current_date.to_s
  end
  erb(:'appointments/index')
end 


get '/appointments/new' do
  @times = AppointmentTime.get_available_times
  erb(:'appointments/new')
end

# create
post '/appointments' do

  Appointment.new(params).save
  redirect to '/appointments'
end


get '/appointments/:id/edit' do
  @appointment = Appointment.find(params[:id])
  @current_time = @appointment.get_time

  @times = AppointmentTime.get_available_times
  @pet = @appointment.get_pet
  @owner = @pet.get_owner
  erb(:"appointments/edit")
end

# show
get '/appointments/:id' do
  @appointment = Appointment.find(params[:id])
  @time = @appointment.get_time.available_time
  @pet = @appointment.get_pet
  @owner = @pet.get_owner
  erb(:"appointments/show")
end

# update
post '/appointments/edit' do 
  Appointment.new(params).update
  redirect to '/appointments/' + params[:id].to_s
end

post '/appointments/delete' do
  Appointment.find(params['id']).delete
  redirect to '/appointments'
end