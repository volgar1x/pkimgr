module Admin::CertProfilesHelper
  def constraint_type(constraint)
    case constraint.type
    when "add_extension" then "Add Extension"
    when "subject_key_type" then "Subject's Key Algorithm"
    when "subject_key_size" then "Subject's Key Size"
    else constraint.type
    end
  end

  def constraint_column(column)
    case column
    when "oid" then "X509 Extension OID"
    when "value" then "X509 Extension Value"
    when "critical" then "X509 Extension Critical"
    else column
    end
  end
end
