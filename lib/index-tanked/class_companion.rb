module IndexTanked
  class ClassCompanion
    attr_reader :fields, :variables, :texts, :index_name, :doc_id_value

    def initialize(options={})
      @fields = []
      @variables = []
      @texts = []
      @index_name = options[:index] || IndexTanked::Configuration.index
      @index_tank_url = options[:url] || IndexTanked::Configuration.url
      raise IndexTanked::IndexTankURLNotProvidedError if @index_tank_url.nil?
      raise IndexTanked::IndexTankIndexNameNotProvidedError if @index_name.nil?
    end

    def doc_id(method)
      @doc_id_value = method
    end

    def field(field_name, method=field_name, options = {})
      method, options = field_name, method if method.is_a? Hash
      @fields <<  [field_name, method, options]
    end

    def text(method)
      @texts << method
    end

    def var(variable, method)
      @variables << [variable, method]
    end

    def index
      api_client.indexes @index_name
    end

    def api_client
      @api_client ||= (IndexTank::Client.new @index_tank_url)
    end

    def get_value_from(instance, method)
      case method
      when Symbol
        instance.send method
      when Proc
        method.call(instance)
      else
        method
      end
    end

  end
end