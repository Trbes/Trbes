class AddHeadlineToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :headline, :string

    Group.all.each do |group|
      group.update_attributes(headline: Faker::Company.catch_phrase)
    end

    change_column_null :groups, :headline, false
  end
end
