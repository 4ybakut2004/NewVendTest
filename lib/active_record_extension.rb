module ActiveRecordExtensions

  extend ActiveSupport::Concern

  module ClassMethods
    PerPage = 10

    def filter(params)
      order('id DESC')
    end

    def page(pg, prm)
      pg = pg.to_i
      self.filter(prm).offset((pg-1)*PerPage).limit(PerPage)
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecordExtensions