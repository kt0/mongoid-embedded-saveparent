require './app/models/task.rb'
require './app/models/project.rb'

Project.all.destroy

project = Project.new title: 'test'
3.times{|i| project.tasks.build title: "task-#{i}"}

project.save

project.reload
puts "\n\n >>>>>  Initial\n"
project.tasks.each do |task|
  puts "  *** #{task.id} => #{task.title}"
end
puts " <<<< Initial\n\n"

puts "\n\n >>>>>  Expected\n"
t = project.tasks[1]
puts "  *** #{t.id} => Updated task #{t.id}"
t = project.tasks[2]
puts "  *** #{t.id} => #{t.title}"
puts " <<<< Expected\n\n"


destroyed = false
threads = []

threads << Thread.new do
  p = Project.first
  task = p.tasks[1]
  while !destroyed
    sleep 1
  end
  puts ">> updating task #{task.id}"
  task.update_attributes title: "Updated task #{task.id}"
  puts ">> task #{task.id} updated"
  p.reload
  puts "\n\n >>>>>  Final\n"
  p.tasks.each do |task|
    puts "  *** #{task.id} => #{task.title}"
  end
  puts " <<<< Final\n\n"
end

threads << Thread.new do
  p = Project.first
  task = p.tasks[0]
  puts ">> destroying task #{task.id}"
  task.destroy
  puts ">> task #{task.id} destroyed"
  destroyed = true
end

threads.each(&:join)
