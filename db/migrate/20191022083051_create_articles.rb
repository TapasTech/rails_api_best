class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.string :summary
      t.text :content
      t.integer :visit_times

      t.timestamps
    end
  end
end
