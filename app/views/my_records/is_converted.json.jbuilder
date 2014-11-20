json.array!(@records) do |record|
  json.extract! record, :id, :converted, :size
end
