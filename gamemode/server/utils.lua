include( "setup.lua" )

GRolePlay.Functions = {}

local jobCount = 0
function GRolePlay.Functions:CreateJob(name, salary, model, description ,command)
	local jobs = {name = name, salary = salary, model = model, command = command}
	
	jobs.name = name
	
	jobCount = jobCount + 1
    jobs.team = jobCount

    jobs.salary = math.floor(jobs.salary)
	
	jobs.description = description
	
	jobs.model = model
	jobs.command = command
	
	table.insert(GRolePlay.Jobs, jobs)
	team.SetUp(#jobs, Name, Color(255,0,0))
    local Team = #jobs

    -- Precache model here. Not right before the job change is done
    if type(jobs.model) == "table" then
        for k,v in pairs(jobs.model) do util.PrecacheModel(v) end
    else
        util.PrecacheModel(jobs.model)
    end
    return Team
end