require('pg')
require_relative ('../db/sql_runner.rb')
require_relative('../models/artist')

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

  def Album.find(id)
    sql = "SELECT * FROM albums 
    WHERE id = #{id};"
    results = SqlRunner.run(sql)
    album_hash = results.first
    album = Album.new(album_hash)
    return album
  end

  def artist()
    sql = "SELECT * FROM artists WHERE id = #{@artist_id};"
    results = SqlRunner.run(sql)
    artist_hash = results.first()
    artist_object = Artist.new(artist_hash)
    return artist_object
  end

  def delete()
    sql = "DELETE FROM albums 
    WHERE id = #{@id};"
    SqlRunner.run(sql)
  end

  def Album.delete_all()
    sql = "DELETE from albums;"
    SqlRunner.run(sql)
  end

end