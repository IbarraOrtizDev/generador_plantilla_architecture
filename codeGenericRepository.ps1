
# Parameters $nameProject
function generaGenericRepository($nameProject){
    dotnet new class -n ConfigurationInit -o src/$nameProject/$nameProject".Infraestructure"/Configurations
    Write-Host "Generando GenericRepository"
    $code = "using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using $nameProject.Domain.Entities;

namespace  $nameProject.Infraestructure.Adapters
{
    public class GenericRepository<T> : IGenericRepository<T> where T : BaseEntity
    {
        private readonly Context _context;
        private readonly DbSet<T> _dbSet;

        public GenericRepository(Context context)
        {
            _context = context;
            _dbSet = context.Set<T>();
        }

        public async Task<IEnumerable<T>> GetAllAsync()
        {
            return await _dbSet.ToListAsync();
        }

        public async Task<IEnumerable<T>> GetByConditionAsync(Expression<Func<T, bool>> expression)
        {
            return await _dbSet.Where(expression).ToListAsync();
        }

        public async Task<T> GetByIdAsync(int id)
        {
            return await _dbSet.FindAsync(id);
        }

        public async Task<T> CreateAsync(T entity)
        {
            await _dbSet.AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<T> UpdateAsync(T entity)
        {
            _dbSet.Update(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task DeleteAsync(T entity)
        {
            _dbSet.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}"

# export code to file
Write-Output $code > $nameProject".Infraestructure"/Adapters/GenericRepository.cs
}