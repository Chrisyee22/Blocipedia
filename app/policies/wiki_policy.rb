class WikiPolicy < ApplicationPolicy

  def update?
    attr_reader :user, :wiki

      def initialize(user, wiki)
        @user = user
        @wiki = wiki
      end

      def index?
        user.present?
      end

      def show?
        scope.where(:id => wiki.id).exists?
      end

      def create?
        user.present?
      end

      def new?
        create?
      end

      def edit?
        update?
      end

      def destroy?
        user.admin?
      end

      def update?
        user.present?
      end
  end
end
