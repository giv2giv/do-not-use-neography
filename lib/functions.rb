

def fetch_sponsor_organization_node()

        return Neography::Node.find(SPONSOR_INDEX,SPONSOR_INDEX,SPONSOR_ORGANIZATION_NAME)

end

def generate_unique_id()
	require 'securerandom'
	return SecureRandom.urlsafe_base64(16)
end
