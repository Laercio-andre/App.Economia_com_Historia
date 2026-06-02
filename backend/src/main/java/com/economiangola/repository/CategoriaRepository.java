// src/main/java/com/economiangola/repository/CategoriaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {

    List<Categoria> findByCategoriaPaiIsNullAndActivaTrueOrderByOrdemAsc();

    Optional<Categoria> findBySlug(String slug);

    boolean existsBySlug(String slug);
}
