require('pg')
require_relative ('../db/sql_runner.rb')

class Album

  attr_accessor :title, :genre
  attr_reader :id, :artist_id

  def initialize(options)
    @title = options['title']
    @genre = options['genre']
    @id = options['id'].to_i if options['id']
    @artist_id = options['artist_id'].to_i() if options['artist_id']
  end

  def save()
    sql = "
    INSERT INTO albums (
      title,
      genre,
      artist_id
    ) VALUES (
      '#{ @title }',
      '#{ @genre }',
       #{ @artist_id }
    )
    RETURNING id;"
    result = SqlRunner.run(sql)
    @id = result[0]["id"].to_i
  end

end