// src/main/java/com/economiangola/repository/ForumTopicoRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ForumTopico;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ForumTopicoRepository extends JpaRepository<ForumTopico, Long> {

    Page<ForumTopico> findByDeletedAtIsNullOrderByFixadoDescCriadoEmDesc(Pageable pageable);

    Page<ForumTopico> findByCategoriaIdAndDeletedAtIsNull(Long categoriaId, Pageable pageable);

    Optional<ForumTopico> findByIdAndDeletedAtIsNull(Long id);

    Optional<ForumTopico> findBySlug(String slug);
}
