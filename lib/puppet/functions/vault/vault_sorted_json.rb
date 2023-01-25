require 'json'

# This function takes data, outputs making sure the hash keys are sorted
#
# *Examples:*
#
#     sorted_json({'key'=>'value'})
#
# Would return: {'key':'value'}
Puppet::Functions.create_function(:'vault::vault_sorted_json') do
    def vault_sorted_json(argument)
        json = argument.delete_if {|key, value| value == :undef }
        return sorted_json(json)
    end

    def sorted_json(obj)
        case obj
            when String, Fixnum, Float, TrueClass, FalseClass, NilClass
                return obj.to_json
            when Array
                arrayRet = []
                obj.each do |a|
                    arrayRet.push(sorted_json(a))
                end
                return "[" << arrayRet.join(',') << "]";
            when Hash
                ret = []
                obj.keys.sort.each do |k|
                    ret.push(k.to_json << ":" << sorted_json(obj[k]))
                end
                return "{" << ret.join(",") << "}";
            else
                raise Exception("Unable to handle object of type <%s>" % obj.class.to_s)
        end
    end
end
