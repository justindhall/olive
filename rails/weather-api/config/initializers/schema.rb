module ActiveRecord
  module Tasks
    module DatabaseTasks
      alias_method :create_current_old, :create_current
      def create_current
        create_current_old
        ActiveRecord::Base.connection.execute "CREATE SCHEMA IF NOT EXISTS #{Rails.application.class.module_parent.to_s.underscore}"
        ActiveRecord::Base.connection.execute "SET search_path = public"
        ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
        ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto"'
        ActiveRecord::Base.connection.execute "SET search_path = #{Rails.application.class.module_parent.to_s.underscore},public"
      end
    end
  end
end
