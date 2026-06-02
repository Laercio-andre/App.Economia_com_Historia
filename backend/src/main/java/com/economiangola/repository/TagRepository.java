// src/main/java/com/economiangola/repository/TagRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Tag;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {

    Optional<Tag> findByNome(String nome);

    Optional<Tag> findBySlug(String slug);

    boolean existsBySlug(String slug);
}
