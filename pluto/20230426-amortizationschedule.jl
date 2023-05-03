### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 1038fa17-359e-4ed0-9017-e6dff94e0b47
begin	
	# Activate environment
    import Pkg
    Pkg.activate(".")

	# Registered packages
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("LaTeXStrings")
	Pkg.add("CSV")
	Pkg.add("DataFrames")
	# Pkg.add("ForwardDiff")
	# Pkg.add("FLOWMath")
	# Pkg.add("SNOW")

	# Import packages
	import Plots
	using PlutoUI
	import LaTeXStrings: @L_str
	import CSV
	import DataFrames: DataFrame
	# import ForwardDiff as FD
	# import FLOWMath
	# import SNOW

	md"""
	## Importing Packages
	"""
end

# ╔═╡ 72de331c-e4a4-11ed-1257-6b98f8b61f0d
html"""
<center>
    <span style="font-size: 1.0em; color:black"><b>
        Calculator
    </b></span>
    <br>
    <span style="font-size: 2.8em; color:black"><b>
        Amortization Schedule
    </b></span>
    <br>
    <span style="font-size: 0.75em;"><i>
        The content of this notebook is intellectual property of <a href="https://edoalvarez.com">Eduardo J. Alvarez</a>. <br>
        No use or sharing of this information is allowed without written consent.
    </i></span> 
</center>
"""

# ╔═╡ 28671bc7-b6a3-4665-9be2-5354396a97ea
begin
	loanamount_select = 
		@bind P0 NumberField(50000:1000:600000, default=264000)
	program_select = 
		@bind Y NumberField(1:50, default=15)
	APR_select = 
		@bind APR NumberField(3:0.125:8, default=5.875)
	
	endyear_select = 
		@bind Yend Slider(0:0.5:30, show_value=true, default=4.5)
		
	md"""	
	| **Loan Terms**  | | **Selling Point** | | 
	|---------: | :---------- | ----------: | :---------- |
	| Loan amount $P_0$: | $(loanamount_select) | When to sell: | $(endyear_select) years |
	| Program: | $(program_select)-year fixed | | |
	| Interest: | $(APR_select)% (APR)| | |
	"""
end

# ╔═╡ a28190ea-0665-411b-903a-d768c00ded3b
md"""
## Schedule
"""

# ╔═╡ e91f987d-8847-45b7-81c0-8d4b1eb34fd8
md"""
### Nominal
"""

# ╔═╡ 3dccc5ba-94fe-40a2-804d-2490e2434760
md"""
### Custom
"""

# ╔═╡ 73f5448d-3156-43e2-9aa7-2b0aa61915f9
begin
	b = @bind reveal html"<input type=checkbox>"
	md"""
	## Backend
	Reveal hidden cells: $(b)
	"""
end

# ╔═╡ 169b9b8c-5992-43fe-bad6-319abfeff3fe
begin
	# Colors
	clru = "#003d6d"
	clrl = "darkred"
	clrt = "black"
	clr0 = "gray"
	clropt = "cyan"

	# Styles
	stlt = :solid
	stl0 = :dash
	stlopt = :solid

	"""
		Calculates the principal+interest monthly payment for an initial
		loan `P0`, monthly interest rate `ir` (fraction), and `N` months
	"""
	function calc_monthypayment(P0, ir, N)
		M = P0 * ir * (1+ir)^N / ( (1+ir)^N - 1 )
	end

	"""
		Calculates the amortization at a given month with an initial principal
		`P`, monthly interest rate `ir` (fraction), and monthly payment `M`.
		See https://www.ramseysolutions.com/real-estate/amortization-schedule.

		Returns: (principal payment, interest payment)
	"""
	function calc_amortization(P, ir, M)
		b = P*ir
		a = M - b
		return a, b
	end

	"""
		Convert nominal dollar to k
	"""
	function dol2k(val; d=1)
		if d==0
			return "\$$(Int(round(val/1000)))k"
		else
			return "\$$(round(val/1000, digits=d))k"
		end
	end
	
	md"""
	## Analysis Functions
	"""
end

# ╔═╡ fd70442e-f89f-4f24-ae48-e99ef1f1603d
begin
	
	# Loan end state at terms
	N = ceil(Int, Y*12)	              # Number of months
	ir = APR/12/100                   # Monthly interest rate (as fraction)
	M = calc_monthypayment(P0, ir, N) # Monthly payment

	totalbyend = M*N                  # Total amount paid by end of loan

	# Loan end state at will
	Nend = ceil(Int, Yend*12)
	
	md"""
	## Calculations
	"""
end

# ╔═╡ 2d42d989-7129-44f7-88d4-8ab1fe513144
begin
	
	start1_select = 
		@bind start1 NumberField(1:N, default=1)
	end1_select = 
		@bind end1 NumberField(1:N, default=12)
	val1_select = 
		@bind val1 NumberField(0:100:5000, default=1200)
	
	start2_select = 
		@bind start2 NumberField(1:N, default=13)
	end2_select = 
		@bind end2 NumberField(1:N, default=24)
	val2_select = 
		@bind val2 NumberField(0:100:5000, default=0)
	
	start3_select = 
		@bind start3 NumberField(1:N, default=25)
	end3_select = 
		@bind end3 NumberField(1:N, default=36)
	val3_select = 
		@bind val3 NumberField(0:100:5000, default=0)

	start4_select = 
		@bind start4 NumberField(1:N, default=37)
	end4_select = 
		@bind end4 NumberField(1:N, default=48)
	val4_select = 
		@bind val4 NumberField(0:100:5000, default=0)
	
	start5_select = 
		@bind start5 NumberField(1:N, default=49)
	end5_select = 
		@bind end5 NumberField(1:N, default=60)
	val5_select = 
		@bind val5 NumberField(0:100:5000, default=0)
	
	fragments_select = [(start1_select, end1_select, val1_select), 
						(start2_select, end2_select, val2_select), 
						(start3_select, end3_select, val3_select), 
						(start4_select, end4_select, val4_select), 
						(start5_select, end5_select, val5_select)]

	md"""
	**Overpayment fragment 1**
	
	start fragment: $(start1_select)
	end fragment: $(end1_select)
	Overpayment: \$$(val1_select)
	
	**Overpayment fragment 2**
	
	start fragment: $(start2_select)
	end fragment: $(end2_select)
	Overpayment: \$$(val2_select)
	
	**Overpayment fragment 3**
	
	start fragment: $(start3_select)
	end fragment: $(end3_select)
	Overpayment: \$$(val3_select)
	
	**Overpayment fragment 4**
	
	start fragment: $(start4_select)
	end fragment: $(end4_select)
	Overpayment: \$$(val4_select)
	
	**Overpayment fragment 5**
	
	start fragment: $(start5_select)
	end fragment: $(end5_select)
	Overpayment: \$$(val5_select)
	"""

	# for (strt, nd, val) in fragments_select
	# 	global str *= md"$(strt)\t$(nd)\t$(val)"
	# end
end

# ╔═╡ c407b966-88fa-49f4-90bb-75e03ab8dc31
begin
	payments = [M for n in 1:N]         # Payment for each month
	
	# Compute amortization schedule
	principal, interest, balance, interesttot = (zeros(N+1) for i in 1:4)
	
	balance[1] = P0                     # Initial condition
	
	for n in 1:N
		a, b = calc_amortization(balance[n], ir, payments[n])
	
		principal[n+1] = a
		interest[n+1] = b
		balance[n+1] = balance[n] - a
		interesttot[n+1] = interesttot[n] + b
	end

	principal = Int.(round.(principal))
	interest = Int.(round.(interest))
	balance = Int.(round.(balance))
	interesttot = Int.(round.(interesttot))
	payment = vcat(0, Int.(round.(payments)))
	
	amortizationschedule = DataFrame(; payment, principal, interest, interesttot, balance)
end

# ╔═╡ 07b58e2c-cdc8-4c17-9d50-a4376ec5fbe8
begin
	fragments = [(start1, end1, val1), (start2, end2, val2), 
					(start3, end3, val3), (start4, end4, val4), 
					(start5, end5, val5)]

	payments_cstm = deepcopy(payments)         # Payment for each month

	for (strt, nd, val) in fragments
		payments_cstm[strt+1:nd+1] .+= val
	end
	
	# Compute amortization schedule
	(principal_cstm, interest_cstm, 
		balance_cstm, interesttot_cstm) = (zeros(N+1) for i in 1:4)
	
	balance_cstm[1] = P0                     # Initial condition
	
	for n in 1:N
		a, b = calc_amortization(balance_cstm[n], ir, payments_cstm[n])
	
		principal_cstm[n+1] = a
		interest_cstm[n+1] = b
		balance_cstm[n+1] = balance_cstm[n] - a
		interesttot_cstm[n+1] = interesttot_cstm[n] + b
	end

	principal_cstm = Int.(round.(principal_cstm))
	interest_cstm = Int.(round.(interest_cstm))
	balance_cstm = Int.(round.(balance_cstm))
	interesttot_cstm = Int.(round.(interesttot_cstm))
	payment_cstm = vcat(0, Int.(round.(payments_cstm)))
	
	amortizationschedule_cstm = DataFrame(; payment=payment_cstm, 
											principal=principal_cstm,
											interest=interest_cstm, 
											interesttot=interesttot_cstm, balance=balance_cstm)	
end

# ╔═╡ 951a81a0-da70-49c4-8daf-0526da8b1b12
begin

	# End state ending at will
	paymenttot_will = sum(payment[1:(Nend+1)])
	principaltot_will = sum(principal[1:(Nend+1)])
	interesttot_will = interesttot[Nend+1]
	balance_will = balance[Nend+1]
	
	# End state ending at will with custom payments
	paymenttot_will_cstm = sum(payment_cstm[1:(Nend+1)])
	principaltot_will_cstm = sum(principal_cstm[1:(Nend+1)])
	interesttot_will_cstm = interesttot_cstm[Nend+1]
	balance_will_cstm = balance_cstm[Nend+1]
	
	md"""	
	| **Loan State**  | **@ $(Y) year** | **@ $(Yend) year** | **@ $(Yend) year** |
	|---------: | :---------- | :---------- | :---------- |
	| Monthly payment $M$ | $(dol2k(M)) | nominal | custom |
	| Total paid | $(dol2k(totalbyend; d=0)) | $(dol2k(paymenttot_will; d=0)) | $(dol2k(paymenttot_will_cstm; d=0)) |
	| Principal paid | $(dol2k(sum(principal); d=0)) | $(dol2k(principaltot_will; d=0)) | $(dol2k(principaltot_will_cstm; d=0)) |
	| **Interest paid** | $(dol2k(totalbyend - P0; d=0)) | **$(dol2k(interesttot_will; d=0))** | **$(dol2k(interesttot_will_cstm; d=0))** |
	| Principal balance | $(dol2k(balance[end]; d=0)) | $(dol2k(balance_will; d=0)) | $(dol2k(balance_will_cstm; d=0)) |

	*Monthly payment $M$ includes only principal and interest* 
	"""
end

# ╔═╡ 7ba9cb51-0e85-419f-acd0-21ad673c7c41
begin
	hide_everything_below =
		html"""
		<style>
		pluto-cell.hide_everything_below ~ pluto-cell {
			display: none;
		}
		</style>
		
		<script>
		const cell = currentScript.closest("pluto-cell")
		
		const setclass = () => {
			console.log("change!")
			cell.classList.toggle("hide_everything_below", true)
		}
		setclass()
		const observer = new MutationObserver(setclass)
		
		observer.observe(cell, {
			subtree: false,
			attributeFilter: ["class"],
		})
		
		invalidation.then(() => {
			observer.disconnect()
			cell.classList.toggle("hide_everything_below", false)
		})
		
		</script>
		""";
	
	md"""
	## Hide Function
	"""
end

# ╔═╡ d4fff2e2-2f0f-480c-b025-f75b43fb2a39
if reveal === true
	md"As you wish!"
else
	hide_everything_below
end

# ╔═╡ 926ef9ca-547a-4c76-ae74-bfe7799e5614
space = html"<br><br><br>";

# ╔═╡ Cell order:
# ╟─72de331c-e4a4-11ed-1257-6b98f8b61f0d
# ╟─28671bc7-b6a3-4665-9be2-5354396a97ea
# ╟─951a81a0-da70-49c4-8daf-0526da8b1b12
# ╟─2d42d989-7129-44f7-88d4-8ab1fe513144
# ╟─a28190ea-0665-411b-903a-d768c00ded3b
# ╟─e91f987d-8847-45b7-81c0-8d4b1eb34fd8
# ╟─c407b966-88fa-49f4-90bb-75e03ab8dc31
# ╟─3dccc5ba-94fe-40a2-804d-2490e2434760
# ╟─07b58e2c-cdc8-4c17-9d50-a4376ec5fbe8
# ╟─73f5448d-3156-43e2-9aa7-2b0aa61915f9
# ╟─d4fff2e2-2f0f-480c-b025-f75b43fb2a39
# ╠═fd70442e-f89f-4f24-ae48-e99ef1f1603d
# ╠═169b9b8c-5992-43fe-bad6-319abfeff3fe
# ╠═1038fa17-359e-4ed0-9017-e6dff94e0b47
# ╠═7ba9cb51-0e85-419f-acd0-21ad673c7c41
# ╟─926ef9ca-547a-4c76-ae74-bfe7799e5614
