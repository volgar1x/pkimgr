def pubid_parse(pubid)
  return nil if pubid[0]  != "["
  return nil if pubid[-1] != "]"

  sep_idx = pubid.index(",", 1)
  return nil if sep_idx < 0

  classname = pubid[1..sep_idx-1]
  pk = pubid[sep_idx+1..-2]

  return [classname, pk]
end

def activerecord_record_by_classname(classname, allowed)
  for recordclass in ApplicationRecord.descendants
    if recordclass.name == classname && allowed.include?(recordclass)
      return recordclass
    end
  end
  return nil
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def pubid
    "[#{self.class.name},#{self.id}]"
  end

  def self.find_by_pubid(pubid, allowed)
    classname, pk = pubid_parse(pubid)
    theclass = activerecord_record_by_classname(classname, allowed)
    theclass && theclass.find(pk)
  end
end
