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

  def Album.all()
    sql = "SELECT * FROM albums;" 
    album_hashes = SqlRunner.run(sql)
    album_objects = album_hashes.map do |album_hash| 
      Album.new(album_hash) 
    end
    return album_objects
  end

  def Album.delete_all()
    sql = "DELETE from albums;"
    SqlRunner.run(sql)
  end

end