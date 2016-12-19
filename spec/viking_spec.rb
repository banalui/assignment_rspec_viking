require "viking"

describe Viking do

	let(:viking) {Viking.new("Behdad", 50)}
	let(:enemy) {Viking.new("Akbar", 30)}
	
	describe '#initialize' do

		it 'sets the name attribute properly' do
			expect(viking.name).to eq("Behdad")
		end

		it 'sets health attribute properly' do
			expect(viking.health).to eq(50)
		end

		it 'cannot override health once frozen' do
			expect(viking).not_to respond_to(:health=)
			expect(viking.health).to eq(50)
		end

		it 'has no weapon on start' do
			expect(viking.weapon).to be_nil
		end

	end

	describe 'pick and drop weapon' do

		it 'can ONLY pick up a valid weapon' do
			a_non_weapon = double("Non Weapon")
			expect{viking.pick_up_weapon(a_non_weapon)}.to raise_error("Can't pick up that thing")
		end

		it 'can pick up any weapon' do
			a_weapon = instance_double("Weapon", is_a?: true)
			expect{viking.pick_up_weapon(a_weapon)}.not_to raise_error
			expect(viking.weapon).to eq(a_weapon)
		end

		it 'can replace a weapon by picking up another weapon' do
			a_weapon = double("Weapon", is_a?: true)
			another_weapon = double("Weapon", is_a?: true)
			expect{viking.pick_up_weapon(a_weapon)}.not_to raise_error
			expect(viking.weapon).to eq(a_weapon)
			expect{viking.pick_up_weapon(another_weapon)}.not_to raise_error
			expect(viking.weapon).to eq(another_weapon)
			expect(viking.weapon).not_to eq(a_weapon)
		end

		it 'can drop its weapon, not it\'s weaponless' do
			a_weapon = double("Weapon", is_a?: true)
			viking.pick_up_weapon(a_weapon)
			expect(viking.weapon).to eq(a_weapon)
			viking.drop_weapon
			expect(viking.weapon).to be_nil
		end

	end

	describe 'cause and recieve attack' do

		it 'can recieve attack and take damage' do
			viking.receive_attack(10)
			expect(viking.health).to eq(40)
		end

		it 'can recieve attack and be less healthy' do
			viking.receive_attack(10)
			expect(viking.health).to eq(40)
		end

		it 'takes damge when being attacked' do
			expect(viking).to receive(:take_damage)
			viking.receive_attack(10)
		end

		it 'can attack another viking' do
			cur_enemy_health = enemy.health
			viking.attack(enemy)
			expect(enemy.health).to be < cur_enemy_health
		end

		it 'can cause another viking to take damage when attacking' do
			expect(enemy).to receive(:take_damage)
			viking.attack(enemy)
		end

		it 'attacks with fist when no weapon available' do
			expect(viking).to receive(:damage_with_fists).and_return(2.5)
			viking.attack(enemy)
		end

		it 'attacks with fist when no weapon available with strength' do
			stronger_viking = Viking.new("Superman", 100,15)
			before_enemy_health = enemy.health
			stronger_viking.attack(enemy)
			after_enemy_health = enemy.health
			expect(before_enemy_health - after_enemy_health).to eq(15*0.25)
		end

		it 'attacks with any weapon with strength' do
			a_weapon = double("Weapon", is_a?: true, use: 0.7)
			stronger_viking = Viking.new("Superman", 100,15, a_weapon)
			before_enemy_health = enemy.health
			stronger_viking.attack(enemy)
			after_enemy_health = enemy.health
			expect(before_enemy_health - after_enemy_health).to eq(15*0.7)
		end

		it 'attacks with weapon when weapon available' do
			a_weapon = double("Weapon", is_a?: true, use: 0.7)
			stronger_viking = Viking.new("Superman", 100,15, a_weapon)
			expect(stronger_viking).to receive(:damage_with_weapon).and_return(5)
			stronger_viking.attack(enemy)
		end

		it 'uses fists instead when attacking with bow and not available' do
			a_bow = instance_double("Bow", is_a?: true, out_of_arrows?: true)
			stronger_viking = Viking.new("Superman", 100,15, a_bow)
			expect(stronger_viking).to receive(:damage_with_fists).and_return(2.5)
			stronger_viking.attack(enemy)
		end

		it 'throws error when viking killed' do
			stronger_viking = Viking.new("Superman", 100,1000)
			expect{stronger_viking.attack(enemy)}.to raise_error("Akbar has Died...")
		end

	end

end