require 'optparse'

module RbFFT
  module CLI
    EXIT_SUCCESS = 0
    ENGINES = {
      'native' => RbFFT::NativeImpl,
      'ruby' => RbFFT::RubyImpl
    }
    DEFAULT_ENGINE = ENGINES['native']
    DEFAULT_SAMPLES = 32
    DEFAULT_FREQS = [2, 5, 11, 17, 29]

    Options = Struct.new(:engine, :samples, :frequencies)

    def self.main(argv, out)
      options = Options.new(DEFAULT_ENGINE, DEFAULT_SAMPLES, DEFAULT_FREQS)

      OptionParser.new do |opts|
        opts.on("--version", "Show the version number") do |v|
          out.puts "v#{RbFFT::VERSION}"
          return EXIT_SUCCESS
        end
        opts.on("-e",
                "--engine ENGINE",
                String,
                ENGINES,
                "The FFT engine to use (#{ENGINES.keys.join(', ')})") do |engine|
          options.engine = engine
        end
        opts.on("-s",
                "--samples SAMPLES",
                Integer,
                "The number of samples to generate") do |samples|
          options.samples = samples
        end
        opts.on("-f",
                "--freqs a,b,c",
                Array,
                "The frequencies to generate") do |frequencies|
          options.frequencies = frequencies.map(&:to_i)
        end
      end.parse!(argv)

      out.puts "#{options.engine} #{options.samples} #{options.frequencies}"

      samples = RbFFT::SignalGen.gen(options.frequencies, options.samples)

      out.puts
      out.puts "Index\tSample"
      out.puts samples.
        each_with_index
        .map { |s, i| format("%3d\t%f", i, s.abs) }
        .join("\n")

      results = options.engine.fft(samples)

      out.puts
      out.puts "Freq\tAmp\tHistogram"
      out.puts results
        .slice(0, options.samples / 2)
        .each_with_index
        .map { |complex, frequency|
          amplitude = complex.abs.round
          format("%3d\t%3d\t%s", frequency, amplitude, '=' * amplitude)
        }
        .join("\n")

      EXIT_SUCCESS
    end
  end
end
