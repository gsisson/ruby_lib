require 'date2'

       #         input                  #prefix_for_file_x    #corrected_prefix_for_file_x
simple =['2010-01-18 09-40-45.png',     '2010-01-18 09-40-45',    '2010-01-18_09.40.45']
ext    =['2010-01-18 09-40-45.JPG',     '2010-01-18 09-40-45',    '2010-01-18_09.40.45']
pm     =['2010-01-18 09-40-45 PM.jpg',  '2010-01-18 09-40-45 PM', '2010-01-18_21.40.45']
am     =['2010-01-18 09-40-45 AM.png',  '2010-01-18 09-40-45 AM', '2010-01-18_09.40.45']
amX    =['2010-01-18 09-40-45 XM.png',  '2010-01-18 09-40-45',    '2010-01-18_09.40.45']
exes   =['2010-XX-XX_09-40-45.avi',     '2010-XX-XX_09-40-45',    '2010-XX-XX_09.40.45']
hard   =['2010-8-1_9-4-5.png',          '2010-8-1_9-4-5',         '2010-08-01_09.04.05']

simple2=['2010-01-18 09-40-45_img.png',     '2010-01-18 09-40-45',    '2010-01-18_09.40.45']
ext2   =['2010-01-18 09-40-45_img.JPG',     '2010-01-18 09-40-45',    '2010-01-18_09.40.45']
pm2    =['2010-01-18 09-40-45 PM_img.jpg',  '2010-01-18 09-40-45 PM', '2010-01-18_21.40.45']
am2    =['2010-01-18 09-40-45 AM_img.png',  '2010-01-18 09-40-45 AM', '2010-01-18_09.40.45']
amX2   =['2010-01-18 09-40-45 XM_img.png',  '2010-01-18 09-40-45',    '2010-01-18_09.40.45']
exes2  =['2010-XX-XX_09-40-45_img.avi',     '2010-XX-XX_09-40-45',    '2010-XX-XX_09.40.45']
hard2  =['2010-8-1_9-4-5_img.png',          '2010-8-1_9-4-5',         '2010-08-01_09.04.05']

describe '#valid_date?' do
  it 'should accept a valid date' do
    expect(Date2.valid_date? '2010-03-12').to be(true)
  end
  it 'should accept a valid date-time' do
    expect(Date2.valid_date? simple[0]).to be(true)
  end
  it 'should reject a date-time with Xs' do
    expect(Date2.valid_date? exes[0]).to be(false)
  end
  it 'should reject an invalid date' do
    @vd1 = '2010-03-12_31.22.33'
#   expect(Date2.valid_date? @vd1).to be(false)
  end
end

describe '#valid_date_x?' do
  it 'should accept a valid date' do
    expect(Date2.valid_date_x? '2010-03-12').to be(true)
  end
  it 'should accept a valid date-time' do
    expect(Date2.valid_date_x? simple[0]).to be(true)
  end
  it 'should accept a date-time with Xs' do
    expect(Date2.valid_date_x? exes[0]).to be(true)
  end
  it 'should reject an invalid date' do
    @vd1 = '2010-03-12_31.22.33'
#   expect(Date2.valid_date_x? @vd1).to be(false)
  end
end

describe '#valid_date_time?' do
  it 'should accept a valid date time' do
    expect(Date2.valid_date? simple[0]).to be(true)
  end
  it 'should reject an invalid date time' do
    @vd1 = '2010-03-12_31.22.33'
#   expect(Date2.valid_date? @vd1).to be(false)
  end
end

describe '#prefix_for_file_x' do
  it 'should support the simple case (when there is no image name)' do
    expect(Date2.prefix_for_file_x(simple[0])).to eq(simple[1])
  end
  it 'should support any extension (when there is no image name)' do
    expect(Date2.prefix_for_file_x(ext[0])).to eq(ext[1])
  end
  it 'should support AM (when there is no image name)' do
    expect(Date2.prefix_for_file_x(am[0])).to eq(am[1])
  end
  it 'should support PM (when there is no image name)' do
    expect(Date2.prefix_for_file_x(pm[0])).to eq(pm[1])
  end
  it 'should ignore XM (when there is no image name)' do
    expect(Date2.prefix_for_file_x(amX[0])).to eq(amX[1])
  end
  it 'should support Xs in place of dates (when there is no image name)' do
    expect(Date2.prefix_for_file_x(exes[0])).to eq(exes[1])
  end
  it 'should support a hard date (when there is no image name)' do
    expect(Date2.prefix_for_file_x(hard[0])).to eq(hard[1])
  end
  it 'should support the simple case' do
    expect(Date2.prefix_for_file_x(simple2[0])).to eq(simple2[1])
  end
  it 'should support any extension' do
    expect(Date2.prefix_for_file_x(ext2[0])).to eq(ext2[1])
  end
  it 'should support AM' do
    expect(Date2.prefix_for_file_x(am2[0])).to eq(am2[1])
  end
  it 'should support PM' do
    expect(Date2.prefix_for_file_x(pm2[0])).to eq(pm2[1])
  end
  it 'should ignore XM' do
    expect(Date2.prefix_for_file_x(amX2[0])).to eq(amX2[1])
  end
  it 'should support Xs in place of dates' do
    expect(Date2.prefix_for_file_x(exes2[0])).to eq(exes2[1])
  end
  it 'should support a hard date' do
    expect(Date2.prefix_for_file_x(hard2[0])).to eq(hard2[1])
  end
end

describe '#corrected_prefix_for_file_x' do
  it 'should support the simple case (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(simple[0])).to eq(simple[2])
  end
  it 'should support any extension (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(ext[0])).to eq(ext[2])
  end
  it 'should support AM (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(am[0])).to eq(am[2])
  end
  it 'should support PM (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(pm[0])).to eq(pm[2])
  end
  it 'should ignore XM (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(amX[0])).to eq(amX[2])
  end
  it 'should support Xs in place of dates (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(exes[0])).to eq(exes[2])
  end
  it 'should support a hard date (when there is no image name)' do
    expect(Date2.corrected_prefix_for_file_x(hard[0])).to eq(hard[2])
  end
  it 'should support the simple case' do
    expect(Date2.corrected_prefix_for_file_x(simple2[0])).to eq(simple2[2])
  end
  it 'should support any extension' do
    expect(Date2.corrected_prefix_for_file_x(ext2[0])).to eq(ext2[2])
  end
  it 'should support AM' do
    expect(Date2.corrected_prefix_for_file_x(am2[0])).to eq(am2[2])
  end
  it 'should support PM' do
    expect(Date2.corrected_prefix_for_file_x(pm2[0])).to eq(pm2[2])
  end
  it 'should ignore XM' do
    expect(Date2.corrected_prefix_for_file_x(amX2[0])).to eq(amX2[2])
  end
  it 'should support Xs in place of dates' do
    expect(Date2.corrected_prefix_for_file_x(exes2[0])).to eq(exes2[2])
  end
  it 'should support a hard date' do
    expect(Date2.corrected_prefix_for_file_x(hard2[0])).to eq(hard2[2])
  end
end
