module HalfAndHalf
  @experiments = []

  def self.experiments
    @experiments
  end

  def self.experiment(name, &block)
    experiment = ExperimentBuilder.new(name, &block).call
    @experiments << experiment
    experiment
  end

  def self.get_experiment(name)
    experiments.find{|e| e.name.to_sym == name.to_sym}
  end

  def self.track_event(event, args)
    experiment_name, variant_name, number = args[:token].split('.')
    Redis.current.setbit(['halfandhalf', experiment_name, variant_name, event].join("."), number, 1)
  end
end