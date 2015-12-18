--[[

 Example lua script demonstrating the SLURM job_submit/lua interface.
 This is only an example, not meant for use in its current form.

 Leave the function names, arguments, local varialbes and setmetatable
 set up logic in each function unchanged. Change only the logic after
 the line containing "*** YOUR LOGIC GOES BELOW ***".

 For use, this script should be copied into a file name "job_submit.lua"
 in the same directory as the SLURM configuration file, slurm.conf.

--]]

function slurm_job_submit (job_desc, part_list, submit_uid)
    --[[
    if job_desc.pn_min_memory == slurm.NO_VAL then                   
        slurm.log_user(" ** ERROR ** You _must_ specify required memory")
        return slurm.ERROR
    end --]]
    -- express jobs can also be handled by the normal partition
    if job_desc.partition == "express" then
        --slurm.log_info("slurm_job_submit: job from uid %d, add 'normal'", job_desc.user_id)
        job_desc.partition = "express,normal"
    end

    if job_desc.std_out == nil and job_desc.std_err == nil and job_desc.name ~= nil then
        job_desc.std_out = job_desc.name .. "-%j.out"
        job_desc.std_err = job_desc.name .. "-%j.out"
    end

    return slurm.SUCCESS
end

function slurm_job_modify(job_desc, job_rec, part_list, modify_uid)
    return 0
end

slurm.log_info("initialized")
return slurm.SUCCESS
