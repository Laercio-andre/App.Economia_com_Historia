// src/main/java/com/economiangola/repository/QuizRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Quiz;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    Optional<Quiz> findBySlug(String slug);

    boolean existsBySlug(String slug);

    Optional<Quiz> findByIdAndDeletedAtIsNull(Long id);

    Page<Quiz> findByDeletedAtIsNullAndActivoTrue(Pageable pageable);

    Page<Quiz> findByCategoriaIdAndDeletedAtIsNullAndActivoTrue(Long categoriaId, Pageable pageable);
}
