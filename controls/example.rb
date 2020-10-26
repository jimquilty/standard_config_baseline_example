# copyright: 2018, The Authors

title 'Standard System Config Baseline'

control 'baseline-01' do
  impact 0.7
  title 'OS Version'
  desc 'Test to make sure the Operating System is at least v7.2.'
  describe os.release do
    it { should cmp >= '7.2' }
  end
end

control 'baseline-02' do
  impact 1.0
  title 'Mem Info'
  desc 'Check that systems have a minimum of 8GB of total memory and at least 3GB of free memory.'
  output = command('cat /proc/meminfo').stdout
  options = {
    assignment_regex: /^\s*([^:]*?)\s*:\s*(.*?)\s*$/,
    multiple_values: false,
  }
  describe parse_config(output, options) do
    its('MemTotal') { should cmp >= '8000000' }
    its('MemFree') { should cmp >= '3000000' }
  end
end

control 'baseline-03' do
  impact 1.0
  title 'CPU Info'
  desc 'Validate the CPU configuration of systems. They should be x86_64 based, have a minimum of 2 CPUs and be a minimum of 2.5GHz.'
  output = command('lscpu').stdout
  options = {
    assignment_regex: /^\s*([^:]*?)\s*:\s*(.*?)\s*$/,
    multiple_values: false,
  }
  describe parse_config(output, options) do
    its('CPU(s)') { should cmp >= 2 }
    its('CPU MHz') { should cmp >= 2500.0 }
    its('Architecture') { should eq 'x86_64' }
  end
end

