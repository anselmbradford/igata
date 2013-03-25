class ChangeStateToIntegerOnTemplates < ActiveRecord::Migration
  def up
    update = <<-SQL
ALTER TABLE templates
  ALTER COLUMN state
    DROP DEFAULT;

ALTER TABLE templates
  ALTER COLUMN state TYPE INTEGER
    USING CASE
      WHEN state = 'cloned'
      THEN 2000
      WHEN state = 'failed'
      THEN 5001
      ELSE 1000
      END;

ALTER TABLE templates
  ALTER COLUMN state
    SET DEFAULT 1000;
    SQL

    execute update
  end

  def down
    update = <<-SQL
ALTER TABLE templates
  ALTER COLUMN state
    DROP DEFAULT;

ALTER TABLE templates
  ALTER COLUMN state TYPE VARCHAR(255)
    USING CASE
      WHEN state = 2000
      THEN 'cloned'
      WHEN state = 5001
      THEN 'failed'
      ELSE 'pending'
      END;

ALTER TABLE templates
  ALTER COLUMN state
    SET DEFAULT 'pending';
    SQL

    execute update
  end
end
