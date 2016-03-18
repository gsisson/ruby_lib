describe 'Pathname' do
  describe '#tildize' do
    it 'should do nothing if not in a home directory path' do
      ENV['HOME']='c:/Users/joe'
      [
       'c:\users\someone\dir\file',
       'c:/users/someone/dir/file',
       'c:/users/someone/cygdrive/file',
       '/cygdrive/d/users/joe/dir/file',
       '/cygdrive/x/file',
       ''
      ].each do |path|
        expect(Pathname.tildize(path)).to eq(path)
      end
    end
    it 'should replace with ~ when in a home directory path' do
      ENV['HOME']='c:/Users/joe'
      expect(Pathname.tildize('c:\users\joe\dir\file')).to eq('~/dir/file')
      ENV['HOME']='/Users/joe'
      expect(Pathname.tildize('\users\joe\dir\file')).to eq('~/dir/file')
    end
  end
end

